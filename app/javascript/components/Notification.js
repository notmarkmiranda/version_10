import React from 'react'

const Notification = ({ notificationText, notificationReadAt, notificationCreatedAt, notificationId, markSingleNotificationAsRead }) => {
  return (
    <div className="dropdown-item">
      { notificationText }
      <div className="caption-text">
        { notificationCreatedAt }
        {
          !notificationReadAt &&
            <span> | <a href="#" onClick={ () =>  markSingleNotificationAsRead(notificationId) } className="muted-text caption-text">mark as read</a></span>
        }
      </div>
    </div>
  )
}

export default Notification
