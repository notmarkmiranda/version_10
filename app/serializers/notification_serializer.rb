require 'action_view'
require 'action_view/helpers'

class NotificationSerializer < ActiveModel::Serializer
  include ActionView::Helpers::DateHelper

  attributes :id, :note_text, :read_at, :decorated_created_at

  def note_text
    object.notification_text
  end

  def decorated_created_at
    object.decorate.decorated_created_at
  end
end
