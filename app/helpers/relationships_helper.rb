module RelationshipsHelper

  def time_for(item, type)
    case type
      when 'invitee'
        "Joined #{time_ago_in_words(item.created_at)} ago"
      when 'invited'
        "Sent invitation #{time_ago_in_words(@user.invitation_sent_on(item))} ago"
      when 'invited_by'
        "Sent invitation #{time_ago_in_words(@user.invitation_sent_on(item))} ago"
      else
        "Became a family member #{time_ago_in_words(@user.invitation_approved_on(item))} ago"
    end
  end

  def relationship_action_for(item, type)
    case type
      when 'invitee'
        link_to 'Invite', relationships_path(user_id: item), method: :post, class: 'pull-right'
      when 'invited'
        link_to 'Cancel', relationship_path(item), method: :delete, class: 'text-muted pull-right',
                data: { confirm: 'you sure you want to cancel this invitation?' }
      when 'invited_by'
        link_to 'Approve', relationship_path(item), method: :patch, class: 'pull-right'
      else
        link_to 'Remove', relationship_path(item), method: :delete, class: 'text-muted pull-right',
                data: { confirm: 'you sure you want to remove this family member?' }
    end
  end


end
