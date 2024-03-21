import { useRef } from "react";
import { upload } from "/src/api";

export default function Upload({ className = "", children, slugs = [] }) {
  const formRef = useRef(null);
  const fileRef = useRef(null);

  const handleSubmit = (e) => {
    e.preventDefault();
    Array.from(fileRef.current.files).forEach((file) => {
      upload(slugs.concat(file.name), file);
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
