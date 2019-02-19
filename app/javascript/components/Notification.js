import React from 'react'

const Notification = ({ notificationText }) => {
  return (
    <div className="dropdown-item">
      { notificationText }
    </div>
  )
}

export default Notification
