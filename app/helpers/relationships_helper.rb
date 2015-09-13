module RelationshipsHelper

  def time_for(item, type)
    case type
    when 'invitee', 'recipient'
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
    when 'recipient'
      links = link_to('Invite', relationships_path(user_id: item), method: :post)
      links << link_to('Cancel', new_relationship_path, class: 'pull-right text-warning')
    when 'invitee'
      link_to 'Invite', relationships_path(user_id: item), method: :post, class: 'pull-right'
    when 'invited'
      link_to 'Cancel', relationship_path(item), method: :delete, class: 'text-muted pull-right',
              data: { confirm: 'you sure you want to cancel this invitation?' }
    when 'invited_by'
      links = link_to('Confirm', relationship_path(item), method: :patch)
      links << link_to('Reject', relationship_path(item), method: :delete, class: 'pull-right text-warning')
    else
      link_to 'Remove', relationship_path(item), method: :delete, class: 'text-muted pull-right',
              data: { confirm: 'you sure you want to remove this family member?' }
    end
  end


end
