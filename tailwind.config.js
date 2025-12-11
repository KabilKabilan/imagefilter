/** @type {import('tailwindcss').Config} */
module.exports = {
  // Specify the paths to all template files
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      // Add custom theme extensions here if needed
      // Example: colors, fonts, spacing, etc.
    },
  },
  plugins: [],
}

