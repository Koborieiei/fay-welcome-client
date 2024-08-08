import { defineConfig } from 'astro/config'
import tailwind from '@astrojs/tailwind'
// https://astro.build/config
export default defineConfig({
  site: 'https://koborieiei.github.io',
  base: 'fay-welcome-client',
  integrations: [tailwind()],
  vite: {
    server: {
      fs: {
        allow: ['/Users/macbookpro/.yarn/'],
      },
    },
  },
})
