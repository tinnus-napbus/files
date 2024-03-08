import React, { useEffect, useState } from "react";
import Urbit from "@urbit/http-api";

const api = new Urbit("", "", window.desk);
api.ship = window.ship;

export function App() {
  return (
    <main className="flex items-center justify-center min-h-screen">
      <h1 className="text-3xl font-bold">%files</h1>
    </main>
  );
}
