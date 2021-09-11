import React from "react";
import Icon from "~/components/icon.tsx";
import Link from "~/components/links.tsx";

export default function Home() {
  return (
    <div className="page">
      <head>
        <title>n4vysh</title>
      </head>
      <p className="icon">
        <Icon />
      </p>
      <h1>
        <strong>n4vysh</strong>
      </h1>
      <p className="links">
        <Link />
      </p>
    </div>
  );
}
