import React from "react";
import "~/style/icon.css";

export default function Link() {
  return (
    <>
      <a href="/keys/gpg" target="_blank">GPG</a>
      <span></span>
      <a href="/keys/ssh" target="_blank">SSH</a>
      <span></span>
      <a
        href="https://github.com/n4vysh"
        target="_blank"
        rel="noopener noreferrer"
      >
        GitHub
      </a>
    </>
  );
}
