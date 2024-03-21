import React, { useEffect, useState } from "react";
import {
  BrowserRouter,
  Routes,
  Route,
  Link,
  useLocation,
  useSearchParams,
} from "react-router-dom";
import api from "/src/api";
import Search from "/src/components/Search";
import Upload from "/src/components/Upload";
import { NewFolderIcon, UploadIcon } from "/src/icons";

function Files() {
  const [fileTree, setFileTree] = useState({});

  const path = decodeURIComponent(useLocation().pathname);
  const slugs = path !== "/" ? path.replace(/^\/|\/$/g, "").split("/") : [];

  const [searchParams] = useSearchParams();
  const [searchQuery] = searchParams.getAll("search");

  useEffect(() => {
    const id = api.subscribe({
      app: "files",
      path: "/did",
      event: (data) => setFileTree(data),
      err: () => console.log("Subscription failed."),
      quit: () => console.log("Subscription closed, kicked by agent."),
    });
    return () => api.unsubscribe(id);
  }, []);

  return (
    <main className="flex h-screen w-screen bg-gray text-2xl px-5 pt-5 space-x-5">
      <div className="space-y-5">
        <h1 className="flex font-mono font-semibold h-[2em] items-center">
          Files
        </h1>
        <div className="flex flex-col gap-1.5">
          <button className="btn bg-white">All Files</button>
          <button className="btn bg-white">Your Files</button>
          <button className="btn bg-white">Public Files</button>
        </div>
      </div>
      <div className="flex-1 flex flex-col gap-1.5">
        <div className="flex items-center h-[2em] w-full gap-5">
          <Search className="h-full w-1/3" />
          <div className="flex-1 flex justify-between items-center">
            <div className="text-lg space-x-1.5">
              <Link className="pill bg-tint" to="">
                ~{api.ship}
              </Link>
              <span>/</span>
            </div>
            <div className="h-full space-x-1.5">
              <button className="inline-flex justify-center items-center h-[2em] w-[2em] rounded-full bg-white text-black">
                <NewFolderIcon className="h-1/2" />
              </button>
              <Upload
                className="h-[2em] pill bg-brite text-white cursor-pointer"
                slugs={slugs}
              >
                <UploadIcon className="h-1/2 mr-[0.25em]" />
                Upload
              </Upload>
            </div>
          </div>
        </div>
        <div className="flex-1 bg-white rounded-t-3xl p-0.5 space-y-0.5"></div>
      </div>
    </main>
  );
}

export function App() {
  return (
    <BrowserRouter basename="/apps/files/">
      <Routes>
        <Route path="*" element={<Files />} />
      </Routes>
    </BrowserRouter>
  );
}
