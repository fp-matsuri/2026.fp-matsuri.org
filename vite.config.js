import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";
import { resolve } from "path";
import { fileURLToPath } from "url";

const __dirname = fileURLToPath(new URL(".", import.meta.url));

export default defineConfig({
  plugins: [tailwindcss()],
  root: "app/arctic_build",
  publicDir: false,
  build: {
    outDir: ".",
    emptyOutDir: false,
    rollupOptions: {
      input: {
        main: resolve(__dirname, "app/arctic_build/index.html"),
        "code-of-conduct": resolve(
          __dirname,
          "app/arctic_build/code-of-conduct/index.html",
        ),
        404: resolve(__dirname, "app/arctic_build/404.html"),
      },
    },
  },
  server: {
    port: 1234,
    open: true,
  },
});
