import React, { useState } from "react";
import { Link } from "react-router-dom";
import { download, del } from "/src/api";
import {
  BinIcon,
  CopyIcon,
  CrossIcon,
  DownloadIcon,
  FileIcon,
  FolderIcon,
  WebIcon,
} from "/src/icons";

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
    <div className="flex flex-col w-full p-0.5 pl-6 rounded-3xl bg-lite">
      <div
        className="flex items-center h-[2em] whitespace-nowrap w-full cursor-default space-x-1.5"
        onMouseEnter={() => setHover(true)}
        onMouseLeave={() => setHover(false)}
      >
        {(mime && (
          <div className="inline-flex flex-1 h-full items-center">
            <FileIcon className="h-1/2 mr-6" />
            {name}
          </div>
        )) || (
          <Link
            className="inline-flex flex-1 h-full items-center"
            to={path.join("/")}
          >
            <FolderIcon className="h-1/2 mr-6" />
            {name}
          </Link>
        )}

        <Button
          className={perm.pub ? "bg-brite text-white" : "bg-tint text-white"}
          onClick={() => console.log(perm)}
          visible={hover}
        >
          <WebIcon className="h-1/2" />
        </Button>
        {/* <Button */}
        {/*   className="bg-brite text-white" */}
        {/*   onClick={() => console.log("copy")} */}
        {/*   visible={hover} */}
        {/* > */}
        {/*   <CopyIcon className="h-1/2" /> */}
        {/* </Button> */}
        <Button
          className="bg-white text-black"
          onClick={() => download(path)}
          visible={hover}
        >
          <DownloadIcon className="h-1/2" />
        </Button>
        <Button
          className="bg-danger text-white"
          onClick={() => del(path)}
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
      {expand && (
        <div className="pt-2.5 pb-6">
          <table className="font-mono table-auto w-max">
            <thead>
              <tr>
                <th className="underline font-normal text-start pr-24">
                  Property
                </th>
                <th className="underline font-normal text-start pr-24">
                  Value
                </th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>Name</td>
                <td>{name}</td>
              </tr>
              <tr>
                <td>Type</td>
                <td>{mime || "folder"}</td>
              </tr>
              <tr>
                <td>Path</td>
                <td>{`~${window.ship}/${path.join("/")}`}</td>
              </tr>
              {size && (
                <tr>
                  <td>Size</td>
                  <td>
                    {size >= 10e5
                      ? `${(size / 10e5).toFixed(1)} MB`
                      : `${(size / 10e2).toFixed(1)} KB`}
                  </td>
                </tr>
              )}
              <tr>
                <td>Public</td>
                <td>{perm.pub ? "Yes" : "No"}</td>
              </tr>
              {date && (
                <tr>
                  <td>Date</td>
                  <td>{date}</td>
                </tr>
              )}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
