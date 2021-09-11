import React from "react";
import "~/style/links.css";

export default function Icon({ size = 75 }: { size?: number }) {
  return (
    <>
      <link rel="stylesheet" href="~/style/icon.css" />
      <img src="/images/icon.svg" height={size} width={size} title="n4vysh" />
    </>
  );
}
