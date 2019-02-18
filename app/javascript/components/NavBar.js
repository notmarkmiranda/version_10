import React, { Component } from 'react'
import PropTypes from 'prop-types'

import UserNav from './UserNav'

class NavBar extends Component {
  constructor
  render () {
    const { isLoggedIn, userAttributes, routes } = this.props.attributes
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
            ? <UserNav routes={ routes } userAttributes={ userAttributes } />
            : <VisitorNav />
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
