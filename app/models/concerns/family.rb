module Family

  extend           ActiveSupport::Concern

  included do
    has_many       :invitations,           dependent:  :destroy

    #####################################################################################
    # relationships
    #####################################################################################
    has_many       :relationships,         dependent:  :destroy

    has_many       :pending_invited,     ->  { where('relationships.pending = ?', true) },   through: :relationships, source: :relative
    has_many       :invited,             ->  { where('relationships.pending = ?', false) },  through: :relationships, source: :relative

    #####################################################################################
    # inverse relationships
    #####################################################################################
    has_many       :inverse_relationships, class_name: 'Relationship', foreign_key: 'relative_id',   dependent: :destroy

    has_many       :pending_invited_by,  ->  { where('relationships.pending = ?', true) },   through: :inverse_relationships, source: :user
    has_many       :invited_by,          ->  { where('relationships.pending = ?', false) },  through: :inverse_relationships, source: :user
  end

  # suggest a user to become a family member.  If the operation succeeds, the method returns true, else false:
  def invite(user)
    return false if user == self || find_any_relationship_with(user)
    Relationship.new { |r| r.user = self ; r.relative = user }.save
  end

  # approve a relationship invitation.  If the operation succeeds, the method returns true, else false:
  def approve(user)
    relationship = find_any_relationship_with(user)
    return false if relationship.nil? || invited?(user)
    relationship.update_attribute(:pending, false)
  end

  # creates a relationship from an invitation token via email:
  def create_relationship_from_invitation(token)
    invitation = Invitation.find_by_token(token)
    Relationship.create(user_id: self.id, relative_id: invitation.user.id, pending: false)
    invitation.delete
  end

  # deletes a relationship:
  def remove_relationship(user)
    relationship = find_any_relationship_with(user)
    return false if relationship.nil?
    relationship.destroy
    self.reload && user.reload if relationship.destroyed?
    true
  end

  # returns the list of approved relatives:
  def relatives
    self.class.where("id in (#{approved_relationships}) OR id in (#{approved_inverse_relationships})")
  end

  # returns users recommended to invite as family members:
  def prospective_relatives
    self.class.where("id NOT IN (#{approved_relationships}) AND id NOT IN (#{approved_inverse_relationships}) AND id NOT IN (#{pending_relationships}) AND id NOT IN (#{pending_inverse_relationships})")
  end

  # total number of invited and invited_by relatives without association loading
  def total_relatives
    self.invited(false).count + self.invited_by(false).count
  end

  # total number of pending_invited and pending_invited_by relatives without association loading
  def total_pending_relatives
    self.pending_invited(false).count + self.pending_invited_by(false).count
  end

  # total number of pending_invited and pending_invited_by relatives without association loading
  def total_prospective_relatives
    self.class.all.count - total_relatives - total_pending_relatives
  end

  # returns the date the relationship was approved via the update method in the controller:
  def invitation_approved_on(user)
    find_any_relationship_with(user).updated_at
  end

  # checks if a user is a relative:
  def related_to?(user)
    relatives.include?(user)
  end

  # checks if a current user is connected to the given user:
  def connected_with?(user)
    find_any_relationship_with(user).present?
  end

  # returns the date of a given invitation:
  def invitation_sent_on(user)
    find_any_relationship_with(user).created_at
  end

  # checks if a current user received an invitation from a given user:
  def invited_by?(user)
    relationship = find_any_relationship_with(user)
    return false if relationship.nil?
    relationship.user_id == user.id
  end

  # checks if a current user invited the given user:
  def invited?(user)
    relationship = find_any_relationship_with(user)
    return false if relationship.nil?
    relationship.relative_id == user.id
  end

  # return the list of ones among its relatives which are also relatives of the given user:
  def common_relatives_with(user)
    self.relatives & user.relatives
  end

  protected

    def find_any_relationship_with(user)
      relationship = Relationship.where(user_id: self.id, relative_id: user.id).first
      if relationship.nil?
        relationship = Relationship.where(user_id: user.id, relative_id: self.id).first
      end
      relationship
    end

    def approved_relationships
      Relationship.where(user_id: self.id, pending: false).select(:relative_id).to_sql
    end

    def approved_inverse_relationships
      Relationship.where(relative_id: self.id, pending: false).select(:user_id).to_sql
    end

    def pending_relationships
      Relationship.where(user_id: self.id, pending: true).select(:relative_id).to_sql
    end

    def pending_inverse_relationships
      Relationship.where(relative_id: self.id, pending: true).select(:user_id).to_sql
    end

end

# TODO:  move instance method queries into scopes.  move to Relationship model.