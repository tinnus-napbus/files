import React, { useState } from "react";
import { Link } from "react-router-dom";
import {
  BinIcon,
  CopyIcon,
  CrossIcon,
  DownloadIcon,
  FileIcon,
  FolderIcon,
  WebIcon,
} from "/src/icons";

function Wrapper({ children, path, mime, onMouseEnter, onMouseLeave }) {
  if (!mime) {
    return (
      <Link
        className="item justify-between"
        to={path.join("/")}
        onMouseEnter={onMouseEnter}
        onMouseLeave={onMouseLeave}
      >
        {children}
      </Link>
    );
  } else {
    return (
      <div
        className="item justify-between cursor-default"
        onMouseEnter={onMouseEnter}
        onMouseLeave={onMouseLeave}
      >
        {children}
      </div>
    );
  }
}

function Button({ className, children, onClick, visible = true }) {
  return (
    <button
      className={`${
        visible ? "" : "hidden "
      }flex justify-center items-center h-full aspect-square font-mono rounded-full ${className}`}
      onClick={(e) => {
        e.preventDefault();
        onClick();
      }}
    >
      {children}
    </button>
  );
}

export default function Item({ name, path, mime, date, size, perm }) {
  const [expand, setExpand] = useState(false);
  const [hover, setHover] = useState(false);

  return (
    <Wrapper
      {...{
        path,
        mime,
        onMouseEnter: () => setHover(true),
        onMouseLeave: () => setHover(false),
      }}
    >
      <div className="inline-flex flex-1 h-full items-center">
        {(!mime && <FolderIcon className="h-1/2 mr-[0.25em]" />) || (
          <FileIcon className="h-1/2 mr-[0.25em]" />
        )}
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
    </Wrapper>
  );
}
