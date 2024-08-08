import { defineConfig } from 'astro/config'
import tailwind from '@astrojs/tailwind'
// https://astro.build/config
export default defineConfig({
  site: 'https://koborieiei.github.io/fay-welcome-client/',
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
