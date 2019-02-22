import React from 'react'

const Notification = ({ notificationText, notificationReadAt, notificationCreatedAt, notificationId, markSingleNotificationAsRead }) => {
  return (
    <a className="dropdown-item" href={ `/notifications/${notificationId}` }>
      { notificationText }
      <div className="caption-text">
        { notificationCreatedAt }
        {
          !notificationReadAt &&
            <span> | <a href="#" onClick={ () =>  markSingleNotificationAsRead(notificationId) } className="muted-text caption-text">mark as read</a></span>
        }
      </div>
    </a>
  )
}

export default Notification
