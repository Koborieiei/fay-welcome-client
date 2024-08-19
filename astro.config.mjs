import { defineConfig } from 'astro/config'
import tailwind from '@astrojs/tailwind'
import icon from 'astro-icon'
// https://astro.build/config
export default defineConfig({
  site: 'https://koborieiei.github.io',
  base: 'fay-welcome-client',
  integrations: [tailwind(), icon()],
  vite: {
    server: {
      fs: {
        allow: ['/Users/macbookpro/.yarn/', '/Users/macbookpro/IdeaProjects/fay-welcome-client/'],
      },
    },
  },
})
