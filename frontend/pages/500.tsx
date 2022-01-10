import React from "react";

export default function E500() {
  return (
    <div className="page">
      <head>
        <title>Internal Server Error - n4vysh</title>
        <link rel="stylesheet" href="~/style/error.css" />
      </head>
      <h1>
        <strong>
          <span className="num">500</span> - Internal Server Error
        </strong>
      </h1>
      <p>The server is currently unable to service your request.</p>
    </div>
  );
}
