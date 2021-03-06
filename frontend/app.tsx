import React, { ComponentType } from "react";
import "./style/app.css";

export default function App(
  // deno-lint-ignore no-explicit-any
  { Page, pageProps }: { Page: ComponentType<any>; pageProps: any },
) {
  return (
    <main>
      <head>
        <meta name="viewport" content="width=device-width" />
        <meta name="description" content="n4vysh's portfolio." />
        <meta name="theme-color" content="black" />
        <link rel="icon" href="/images/icon.png" />
        <link rel="apple-touch-icon" href="/images/icon.png" />
      </head>
      <Page {...pageProps} />
    </main>
  );
}
