import React, { useEffect, useState } from "react";
import {
  BrowserRouter,
  Routes,
  Route,
  Link,
  Navigate,
  useLocation,
} from "react-router-dom";
import api, { dir } from "/src/api";
import Search from "/src/components/Search";
import Upload from "/src/components/Upload";
import { File, Folder, NewFolderIcon, UploadIcon } from "/src/icons";

function Dir({ name, path, perm }) {
  return (
    <Link className="h-[2em] w-full pill !px-6 bg-lite" to={path.join("/")}>
      <div className="inline-flex h-full items-center">
        <Folder className="h-1/2 mr-[0.25em]" />
        {name}
      </div>
    </Link>
  );
}

function Fil({ name, path, mime, date, size, perm }) {
  return (
    <div className="h-[2em] w-full pill !px-6 bg-lite">
      <div className="inline-flex h-full items-center">
        <File className="h-1/2 mr-[0.25em]" />
        {name}
      </div>
    </div>
  );
}

function Path({ slugs }) {
  let crumbs = [];
  slugs.forEach((slug, i) => {
    crumbs.push(<span>/</span>);
    crumbs.push(<Link to={slugs.slice(0, i + 1).join("/")}>{slug}</Link>);
  });

  return (
    <div className="text-lg space-x-1.5">
      <Link className="pill bg-tint" to="">
        ~{api.ship}
      </Link>
      {...crumbs}
    </div>
  );
}

function Files() {
  const [fileTree, setFileTree] = useState({});
  const [query, setQuery] = useState(null);

  const path = decodeURIComponent(useLocation().pathname);
  const slugs = path !== "/" ? path.replace(/^\/|\/$/g, "").split("/") : [];

  const assoc = (o, k, v) => {
    const res = { ...o };
    res[k] = v;
    return res;
  };

  const dissoc = (o, k) => {
    const res = { ...o };
    delete res[k];
    return res;
  };

  const flattenFiles = ({ dir }) => {
    const { name, path, contents, perm } = dir || {};
    if (contents) {
      return [
        dissoc(assoc(dir, "type", "dir"), "contents"),
        ...contents
          .filter((o) => "fil" in o)
          .map((o) => assoc(o.fil, "type", "fil")),
        ...contents
          .filter((o) => "dir" in o)
          .map((d) => flattenFiles(d))
          .flat(),
      ];
    } else {
      return [];
    }
  };

  const flatAllFiles = flattenFiles(fileTree);
  const flatFiles = flatAllFiles.filter((o) => {
    return (
      o.path.length > 0 &&
      (query || o.path.slice(0, -1).join("/") === slugs.join("/")) &&
      (!query || o.name.includes(query || ""))
    );
  });
  const flatFils = flatFiles.filter((o) => o.type === "fil");
  const flatDirs = flatFiles.filter((o) => o.type === "dir");

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
          <Search className="h-full w-1/3" search={setQuery} />
          <div className="flex-1 flex justify-between items-center">
            <Path slugs={slugs} />
            <div className="h-full space-x-1.5">
              <button
                className="inline-flex justify-center items-center h-[2em] w-[2em] rounded-full bg-white text-black"
              >
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
        <div className="flex-1 bg-white rounded-t-3xl p-0.5 space-y-0.5">
          {flatDirs.map((props) => (
            <Dir key={props.path.join("/")} {...props} />
          ))}
          {flatFils.map((props) => (
            <Fil key={props.path.join("/")} {...props} />
          ))}
        </div>
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
