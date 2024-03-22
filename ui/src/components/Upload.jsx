import { useRef } from "react";
import { upload } from "/src/api";

export default function Upload({
  className = "",
  children,
  slugs = [],
  addUploadFiles,
  updateProgress,
  uploadDone,
}) {
  const formRef = useRef(null);
  const fileRef = useRef(null);

  const handleSubmit = (e) => {
    e.preventDefault();

    const files = Array.from(fileRef.current.files).map(
      ({ name, type, size, lastModified, lastModifiedDate }) => ({
        name,
        type,
        size,
        lastModified,
        lastModifiedDate,
        path: slugs.concat(name).join("/"),
        progress: 0,
      })
    );

    addUploadFiles(files);

    files.forEach((file) => {
      upload(
        slugs.concat(file.name),
        file,
        (progress) => updateProgress(file.path, file.progress),
        () => uploadDone(file.path)
      );
    });
  };

  return (
    <form className="inline" ref={formRef} onSubmit={handleSubmit}>
      <label htmlFor="file-upload" className={className}>
        {...children}
      </label>
      <input
        className="hidden"
        id="file-upload"
        ref={fileRef}
        type="file"
        multiple
        onChange={(e) => {
          formRef.current.dispatchEvent(
            new Event("submit", { cancelable: true, bubbles: true })
          );
          fileRef.current.value = null;
        }}
      />
    </form>
  );
}
