class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :note_text

  def note_text
    object.notification_text
  end
end
