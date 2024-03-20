import Urbit from "@urbit/http-api";
import axios from "axios";

const api = new Urbit("", "", window.desk || "files");
api.ship = window.ship;

export async function upload(slugs, file) {
  await axios.post(`/files-upload/${slugs.join("/")}`, file, {
    headers: {
      Accept: "application/json",
      "Content-Type": file.type,
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

export default api;
