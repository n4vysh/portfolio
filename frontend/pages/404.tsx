import React from "react";

export default function E404() {
  return (
    <div className="page">
      <head>
        <title>Page Not Found - n4vysh</title>
        <link rel="stylesheet" href="~/style/error.css" />
      </head>
      <h1>
        <strong>
          <span className="num">404</span> - Page Not Found
        </strong>
      </h1>
      <p>You just hit a route that doesn&#39;t exist.</p>
    </div>
  );
}
