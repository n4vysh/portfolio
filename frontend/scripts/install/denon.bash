#!/bin/bash

type denon >/dev/null 2>&1 ||
	deno install -qAf --unstable https://deno.land/x/denon@2.4.10/denon.ts
