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
  return await axios
    .get(`/files/${slugs.join("/")}`, {
      responseType: "blob",
      headers: {
        Accept: "*",
      },
    })
    .then((res) => {
      const data = res.data;
      const filename = slugs[slugs.length - 1];
      const mime = res.data.type;
      var blobData = [data];
      var blob = new Blob(blobData, {
        type: mime || "application/octet-stream",
      });
      if (typeof window.navigator.msSaveBlob !== "undefined") {
        // IE workaround for "HTML7007: One or more blob URLs were
        // revoked by closing the blob for which they were created.
        // These URLs will no longer resolve as the data backing
        // the URL has been freed."
        window.navigator.msSaveBlob(blob, filename);
      } else {
        var blobURL =
          window.URL && window.URL.createObjectURL
            ? window.URL.createObjectURL(blob)
            : window.webkitURL.createObjectURL(blob);
        var tempLink = document.createElement("a");
        tempLink.style.display = "none";
        tempLink.href = blobURL;
        tempLink.setAttribute("download", filename);

        // Safari thinks _blank anchor are pop ups. We only want to set _blank
        // target if the browser does not support the HTML5 download attribute.
        // This allows you to download files in desktop safari if pop up blocking
        // is enabled.
        if (typeof tempLink.download === "undefined") {
          tempLink.setAttribute("target", "_blank");
        }

        document.body.appendChild(tempLink);
        tempLink.click();

        // Fixes "webkit blob resource error 1"
        setTimeout(function () {
          document.body.removeChild(tempLink);
          window.URL.revokeObjectURL(blobURL);
        }, 200);
      }
    });
}

export function dir(slugs) {
  return api.poke({
    app: api.desk,
    mark: "files-do",
    json: { dir: { way: slugs, perm: false } },
    onError: () => console.log("dir error"),
    onSuccess: () => console.log("dir success"),
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

export function pub(slugs, isPublic) {
  return api.poke({
    app: api.desk,
    mark: "files-do",
    json: { pub: { way: slugs, perm: isPublic } },
    onError: () => console.log("pub error"),
    onSuccess: () => console.log("pub success"),
  });
}

export default api;
