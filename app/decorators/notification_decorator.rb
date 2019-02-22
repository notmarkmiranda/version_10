class NotificationDecorator < ApplicationDecorator
  delegate_all

  def decorated_created_at
    "#{h.time_ago_in_words(object.created_at)} ago"
  end

  def mark_as_read_link
    unless object.read_at
      "| #{h.link_to 'mark as read', '#'}"
    end
  end

  def navbar_mark_as_read_link
    unless object.read_at
      h.content_tag :div do
        h.link_to 'mark as read', '#', class: 'muted-text caption-text'
      end
    end
  end

  def notification_status
    notifiable_object = object.notifiable
    if notifiable_object.approved?
      "#{object.notifiable.status} #{h.time_ago_in_words(notifiable_object.updated_at)} ago"
    else
      "#{h.time_ago_in_words(object.created_at)} ago"
    end
  end
end
