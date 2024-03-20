module.exports = {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      fontFamily: {
        sans: ["Urbit Sans"],
        mono: ["Urbit Sans", { fontVariationSettings: '"xtab" 500' }],
      },
      fontSize: {
        base: ["1rem", { lineHeight: "1.34", letterSpacing: "0.024em" }],
        lg: ["1.125rem", { lineHeight: "1.34", letterSpacing: "0.024em" }],
        xl: ["1.3125rem", { lineHeight: "1.3", letterSpacing: "0.024em" }],
        "2xl": ["1.5rem", { lineHeight: "1.25", letterSpacing: "0.024em" }],
        "3xl": ["1.875rem", "1.1"],
        "4xl": ["2.25rem", "1.1"],
      },
      colors: {
        black: "var(--black)",
        white: "var(--white)",
        lite: "var(--lite)",
        gray: "var(--gray)",
        tint: "var(--tint)",
        brite: "var(--brite)",
        danger: "var(--danger)",
      },
    },
  },
  screens: {},
  variants: {
    extend: {},
  },
  plugins: [],
};
