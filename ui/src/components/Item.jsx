import React, { useState } from "react";
import {
  BinIcon,
  CopyIcon,
  CrossIcon,
  DownloadIcon,
  FileIcon,
  WebIcon,
} from "/src/icons";

function Button({ className, children, onClick, visible = true }) {
  return (
    <button
      className={`${
        visible ? "" : "hidden "
      }flex justify-center items-center h-full aspect-square font-mono rounded-full ${className}`}
      onClick={onClick}
    >
      {children}
    </button>
  );
}

export default function Item({ name, path, mime, date, size, perm }) {
  const [expand, setExpand] = useState(false);
  const [hover, setHover] = useState(false);

  return (
    <div
      className="item justify-between cursor-default"
      onMouseEnter={() => setHover(true)}
      onMouseLeave={() => setHover(false)}
    >
      <div className="inline-flex flex-1 h-full items-center">
        <FileIcon className="h-1/2 mr-[0.25em]" />
        {name}
      </div>
      <div className="flex h-full space-x-1.5">
        <Button
          className={perm.pub ? "bg-brite text-white" : "bg-gray text-white"}
          onClick={() => console.log(perm)}
          visible={hover}
        >
          <WebIcon className="h-1/2" />
        </Button>
        <Button
          className="bg-brite text-white"
          onClick={() => console.log("copy")}
          visible={hover}
        >
          <CopyIcon className="h-1/2" />
        </Button>
        <Button
          className="bg-white text-black"
          onClick={() => console.log("download")}
          visible={hover}
        >
          <DownloadIcon className="h-1/2" />
        </Button>
        <Button
          className="bg-danger text-white"
          onClick={() => console.log("delete")}
          visible={hover}
        >
          <BinIcon className="h-1/2" />
        </Button>
        <Button
          className="bg-white text-black"
          onClick={() => setExpand(!expand)}
        >
          {expand ? <CrossIcon className="h-1/3" /> : "i"}
        </Button>
      </div>
    </div>
  );
}
