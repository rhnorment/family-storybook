module Family

  extend    ActiveSupport::Concern

  included do
    has_many            :relationships,         dependent:  :destroy
    has_many            :inverse_relationships, class_name: 'Relationship', foreign_key: 'relative_id',   dependent: :destroy
    has_many            :invited_relatives,     ->  { where('relationships.pending = ?', true) },   through: :relationships, source: :relative
    has_many            :relatives,             ->  { where('relationships.pending = ?', false) },  through: :relationships, source: :relative
    has_many            :invited_by_relatives,  ->  { where('relationships.pending = ?', true) },   through: :inverse_relationships, source: :user
    has_many            :inverse_relatives,     ->  { where('relationships.pending =?', false) },   through: :inverse_relationships, source: :user
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

  # deletes a relationship:
  def remove_relationship(user)
    relationship = find_any_relationship_with(user)
    return false if relationship.nil?
    relationship.destroy
  end

  # checks if a current user invited the given user:
  def invited?(user)
    relationship = find_any_relationship_with(user)
    return false if relationship.nil?
    relationship.relative_id == user.id
  end

  # returns relationship with given user or nil
  def find_any_relationship_with(user)
    relationship = Relationship.where(user_id: self.id, relative_id: user.id).first
    if relationship.nil?
      relationship = Relationship.where(user_id: user.id, relative_id: self.id).first
    end
    relationship
  end

end