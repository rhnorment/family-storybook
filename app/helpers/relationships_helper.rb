module RelationshipsHelper

  def date_for(item, type)
    case type
      when 'relative'
        "Added as a family member #{time_ago_in_words(@user.invitation_approved_on(item))} ago"
      when 'incoming'
        "Invitation sent #{time_ago_in_words(item.invitation_sent_on(@user))} ago"
      when 'outgoing'
        "Invitation sent #{time_ago_in_words(@user.invitation_sent_on(item))} ago"
      else
        "Joined #{time_ago_in_words(item.created_at)} ago"
    end
  end

  def relationship_action_for(item, type)
    case type
      when 'relative'
        link_to 'Remove', relationship_path(item), class: 'text-muted text-small', method: :delete, data: { confirm: 'you want to remove this relationship?' }
      when 'incoming'
        link_to 'Approve', relationship_path(item), class: 'text-success text-small', method: :patch
      when 'outgoing'
        link_to 'Cancel', relationship_path(item), class: 'text-muted text-small', method: :delete, data: { confirm: 'you want to cancel this invitation?' }
      else
        link_to 'Invite', relationships_path(user_id: item.id), class: 'text-primary text-small', method: :post
    end
  end


end
