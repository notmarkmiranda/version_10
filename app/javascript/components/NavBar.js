import React, { Component } from 'react'
import PropTypes from 'prop-types'
import axios from 'axios'

import UserNav from './UserNav'
import VisitorNav from './VisitorNav'

class NavBar extends Component {
  constructor(props) {
    super(props)
    this.state = { ...props.attributes }
  }

  componentDidMount() {
    if (this.state.isLoggedIn) {
      axios.get(this.state.routes.lastFiveNotificationsPath)
        .then((response) => {
          this.setState({ notifications: response.data })
        })
    } else {
    }
  }

  markSingleNotificationAsRead = (notificationId) => {
    const csrfToken = document.querySelector('[name="csrf-token"]').content;
    axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;

    if (notificationId) {
      axios.patch(`/api/v1/notifications/${notificationId}/mark_as_read`)
        .then((response) => {
          const index = this.state.notifications.findIndex((notification) => notification.id === notificationId)
          const updatedNotifications = this.state.notifications
          updatedNotifications[index] = response.data
          const newUserAttributes = { ...this.state.userAttributes }

          const newUnreadCount = this.state.userAttributes.unreadNotificationCount - 1
          newUserAttributes.unreadNotificationCount = newUnreadCount

          this.setState({ notifications: updatedNotifications, userAttributes: newUserAttributes })
        })
        .catch((error) => {
          console.log(error);
        })
    } else {
      axios.patch(`/api/v1/notifications/mark_as_read`)
        .then((response) => {
          const updatedNotifications = response.data

          const newUserAttributes = { ...this.state.userAttributes }
          newUserAttributes.unreadNotificationCount = 0

          this.setState({ notifications: updatedNotifications, userAttributes: newUserAttributes })
        })
        .catch((error) => {
          console.log(error);
        })
    }
    // make api call
  }

  render () {
    const { isLoggedIn, userAttributes, routes, notifications } = this.state
    const { rootPath } = routes
    return (
      <nav className="navbar navbar-expand-lg navbar-light bg-light">
        <div className="container">
          <a href={ rootPath } className="navbar-brand">
            Poker<span>Rank</span>
          </a>

          <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
            <span className="navbar-toggler-icon"></span>
          </button>
          { isLoggedIn
            ? <UserNav
                routes={ routes }
                userAttributes={ userAttributes }
                notifications={ notifications }
                markSingleNotificationAsRead={ this.markSingleNotificationAsRead }
              />
            : <VisitorNav routes={ routes } />
          }
        </div>
      </nav>
    );
  }
}

NavBar.propTypes = {
  email: PropTypes.string,
  rootPath: PropTypes.string,
  leaguesPath: PropTypes.string
};

export default NavBar
