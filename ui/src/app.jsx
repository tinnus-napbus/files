import React, { useEffect, useState, useRef } from "react";
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

function NewDir({ slugs, callback }) {
  const nameRef = useRef(null);

  const onSubmit = (e) => {
    e.preventDefault();
    dir(slugs.concat(nameRef.current.value));
    callback();
    return false;
  };

  return (
    <div className="h-[2em] w-full pill !px-6 bg-tint justify-between">
      <div className="inline-flex h-full items-center">
        <Folder className="h-1/2 mr-[0.25em]" />
        <form onSubmit={onSubmit}>
          <input
            className="bg-transparent focus:outline-0"
            ref={nameRef}
            type="text"
            defaultValue={"New Folder"}
            onFocus={(e) => e.target.select()}
            onBlur={(e) => callback()}
            autoFocus
          />
        </form>
      </div>
    </div>
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

function UploadFile({ name, type, progress }) {
  return (
    <div className="relative h-[2em] w-full pill !pl-6 !pr-0.5 !py-0.5 bg-lite justify-between">
      <div
        className="absolute left-0 top-0 h-full bg-tint rounded-full"
        style={{ width: `${progress}%` }}
      />
      <div className="z-10 inline-flex h-full items-center">
        <File className="h-1/2 mr-[0.25em]" />
        {name}
      </div>
      <div className="z-10 flex justify-center items-center h-full aspect-square bg-white text-lg rounded-full">
        {progress}%
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
  const [action, setAction] = useState(null);

  const [uploadFiles, setUploadFiles] = useState([]);
  const uploadFilesRef = useRef(uploadFiles);
  useEffect(() => {
    uploadFilesRef.current.value = uploadFiles;
  }, [uploadFiles]);

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
                onClick={(e) => setAction("mkdir")}
              >
                <NewFolderIcon className="h-1/2" />
              </button>
              <Upload
                className="h-[2em] pill bg-brite text-white cursor-pointer"
                slugs={slugs}
                addUploadFiles={(files) =>
                  setUploadFiles(
                    (uploadFilesRef.current.value || []).concat(...files)
                  )
                }
                updateProgress={(path, progress) => {
                  let updatedFiles = [...uploadFilesRef.current.value];
                  const updateIndex = updatedFiles.findIndex(
                    (file) => file.path === path
                  );
                  updatedFiles[updateIndex].progress = progress;
                  setUploadFiles(updatedFiles);
                }}
                uploadDone={(path) => {
                  let updatedFiles = [...uploadFilesRef.current.value];
                  const delIndex = updatedFiles.findIndex(
                    (file) => file.path === path
                  );
                  updatedFiles.splice(delIndex, 1);
                  setUploadFiles(updatedFiles);
                }}
              >
                <UploadIcon className="h-1/2 mr-[0.25em]" />
                Upload
              </Upload>
            </div>
          </div>
        </div>
        <div className="flex-1 bg-white rounded-t-3xl p-0.5 space-y-0.5 overflow-y-auto">
          {action === "mkdir" && (
            <NewDir slugs={slugs} callback={() => setAction(null)} />
          )}
          {uploadFiles.length > 0 &&
            uploadFiles.map((props) => (
              <UploadFile key={props.path} {...props} />
            ))}
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
