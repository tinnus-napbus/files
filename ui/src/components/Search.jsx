import { SearchIcon } from "/src/icons";

export default function Search({ className = "", search }) {
  const handleChange = (e) => {
    search(e.target.value);
  };

  const handleReset = (e) => {
    search(null);
  };

  return (
    <form
      className={`flex items-center px-5 rounded-full bg-white ${className}`}
      onSubmit={(e) => {
        e.preventDefault();
        return false;
      }}
    >
      <label id="search-label" htmlFor="search-input">
        <SearchIcon className="h-[0.8em] text-black" />
      </label>
      <input
        className="appearance-none outline-none placeholder-black bg-transparent px-3 h-full w-full"
        id="search-input"
        name="search"
        placeholder="Search"
        maxLength="64"
        enterKeyHint="go"
        aria-activedescendant="search-item-0"
        aria-controls="search-list"
        aria-labelledby="search-label"
        onChange={handleChange}
      />
      <button
        id="search-reset"
        htmlFor="search-input"
        type="reset"
        title="Clear the query"
        aria-label="Clear the query"
        onClick={handleReset}
      >
        <svg width="20" height="20" viewBox="0 0 20 20">
          <path
            d="M10 10l5.09-5.09L10 10l5.09 5.09L10 10zm0 0L4.91 4.91 10 10l-5.09 5.09L10 10z"
            stroke="currentColor"
            fill="none"
            fillRule="evenodd"
            strokeLinecap="round"
            strokeLinejoin="round"
          />
        </svg>
      </button>
    </form>
  );
}
