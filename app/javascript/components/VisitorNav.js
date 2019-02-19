import React from 'react'

const VisitorNav = ({ routes }) => {
  const { newUserSessionPath, newUserRegistrationPath, leaguesPath } = routes
  return (
    <div className="collapse navbar-collapse" id="navbarSupportedContent">
      <ul className="navbar-nav ml-auto">
        <li className="nav-item">
          <a href={ leaguesPath } className="nav-link">
            Public Leagues
          </a>
        </li> { /*public_leagues nav-link*/ }
        <li className="nav-item">
          <a href={ newUserSessionPath } className="nav-link">
            Log In
          </a>
        </li> { /*log in link*/ }
        <li className="nav-item">
          <a href={ newUserRegistrationPath } className="nav-link">
            Sign Up
          </a>
        </li> { /*log in link*/ }
      </ul>
    </div>
  )
}

export default VisitorNav
