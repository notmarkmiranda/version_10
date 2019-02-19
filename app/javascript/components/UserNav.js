import React, { Component } from 'react'

import Notification from './Notification'

class UserNav extends Component {
  renderNotifications = (notes) => {
    return notes.map((note) => {
      return <Notification notificationText={ note.note_text } />
    })
  }

  render() {
    const { routes, userAttributes, notifications } = this.props
    const { leaguesPath, dashboardPath, newLeaguePath, destroyUserSessionPath, notificationsPath } = routes
    const { currentUserEmail, notificationCount } = userAttributes

    return (
      <div className="collapse navbar-collapse" id="navbarSupportedContent">
        <ul className="navbar-nav ml-auto">
          <li className="nav-item">
            <a href={ leaguesPath } className="nav-link">
              Public Leagues
            </a>
          </li> { /*public_leagues nav-link*/ }
          <li className="nav-item">
            <a href={ dashboardPath } className="nav-link">
              Dashboard
            </a>
          </li> { /* dashboard nav-link */ }
          <li className="nav-item dropdown">
            <a className="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              { currentUserEmail }
            </a>
            <div className="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
              <a href={ newLeaguePath } className="dropdown-item">
                Create League
              </a>
              <div className="dropdown-divider"></div>
              <a href={ destroyUserSessionPath } rel="nofollow" className="dropdown-item" data-method="delete">
                Log Out
              </a>
            </div>
          </li> { /* user dropdown */ }
          <li className="nav-item-dropdown">
            <a className="nav-link" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
              <h6>
                <span className="badge badge-info dropdown-toggle">
                  { notificationCount }
                </span>
              </h6>
            </a>
            <div className="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdown">
              {
                notifications
                ? this.renderNotifications(notifications)
                : <div>nope</div>
              }
            <div className="dropdown-divider"></div>
            <a href={ notificationsPath } className="dropdown-item">view all notifications</a>
            <a href='#' className="dropdown-item">mark all as read</a>
            </div>
          </li> { /* notifications dropdown */ }
        </ul>
      </div>
    )
  }
}

export default UserNav
