import Urbit from "@urbit/http-api";
import axios from "axios";

const api = new Urbit("", "", window.desk || "files");
api.ship = window.ship;

export async function upload(slugs, file, onProgress, onDone) {
  await axios.post(`/files-upload/${slugs.join("/")}`, file, {
    headers: {
      Accept: "application/json",
      "Content-Type": file.type,
    },
    onUploadProgress: (progressEvent) => {
      const progress = (progressEvent.loaded / progressEvent.total) * 100;
      onProgress(progress);
    },
    onDownloadProgress: (progressEvent) => {
      const progress = (progressEvent.loaded / progressEvent.total) * 100;
      if (progress === 100) onDone();
    },
  });
}

export async function download(slugs) {
  return await axios.get(slugs, {
    headers: {
      Accept: "*",
    },
    onUploadProgress: (progressEvent) => {
      const progress = (progressEvent.loaded / progressEvent.total) * 100;
      console.log(progress);
    },
    onDownloadProgress: (progressEvent) => {
      const progress = (progressEvent.loaded / progressEvent.total) * 100;
      console.log(progress);
    },
  });
}

export function dir(slugs) {
  return api.poke({
    app: api.desk,
    mark: "files-do",
    json: { dir: { way: slugs, perm: false } },
    onError: () => console.log("mkdir error"),
    onSuccess: () => console.log("mkdir success"),
  });
}

export function del(slugs) {
  return api.poke({
    app: api.desk,
    mark: "files-do",
    json: { del: { way: slugs } },
    onError: () => console.log("del error"),
    onSuccess: () => console.log("del success"),
  });
}

export default api;
