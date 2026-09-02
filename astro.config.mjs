// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import sitemap from '@astrojs/sitemap';
import { SITE_DATA } from './src/constants';



// https://astro.build/config
export default defineConfig({
site: 'https://coresystem.vn',
base: '/',
trailingSlash: "ignore",
  integrations: [
    sitemap(),
    starlight({
      title: SITE_DATA.name,                 // "CoreSystem"
      titleDelimiter: '|',
      description: SITE_DATA.description,    // mô tả dịch vụ chính, giữ nguyên
      favicon: '/favicon.svg',
      defaultLocale: 'root',
      locales: {
        root: { label: 'Tiếng Việt', lang: 'vi' },
        en: { label: 'English', lang: 'en' },
      },
      disable404Route: true,                  // dùng src/pages/404.astro hiện có
      pagefind: false,                        // tắt searchbar
      customCss: ['./src/styles/starlight.css'],
    components: {
      SiteTitle: './src/components/SiteTitle.astro',
      ThemeSelect: './src/components/ThemeToggle.astro',
      PageSidebar: './src/components/PageSidebar.astro',
      Footer: './src/components/DocsFooter.astro',
    },
    sidebar: [
      { label: 'EasyDeploy', link: '/easydeploy/', translations: { en: 'EasyDeploy' } },
      {
        label: 'Bắt đầu nhanh',
        translations: { en: 'Quick Start' },
        items: [
          { slug: 'easydeploy/getting-started/quick-start' },
          { slug: 'easydeploy/getting-started/deploy-modes' },
          { slug: 'easydeploy/getting-started/rescue-tools' },
        ],
      },
      {
        label: 'MSP & Bản quyền',
        translations: { en: 'MSP & Licensing' },
        items: [
          { slug: 'easydeploy/msp/license-tiers' },
          { slug: 'easydeploy/msp/getting-started' },
          { slug: 'easydeploy/msp/bootbuilder' },
        ],
      },
      {
        label: 'Tùy biến Profiles',
        translations: { en: 'Custom Profiles' },
        collapsed: true,
        items: [
          { slug: 'easydeploy/profiles/profiles' },
          { slug: 'easydeploy/profiles/unattend-xml' },
          { slug: 'easydeploy/profiles/post-setup-ps1' },
          { slug: 'easydeploy/profiles/creating-new-profile' },
        ],
      },
      {
        label: 'Tham khảo',
        translations: { en: 'Reference' },
        collapsed: true,
        items: [
          { slug: 'easydeploy/reference/configuration' },
          { slug: 'easydeploy/reference/keyboard-shortcuts' },
          { slug: 'easydeploy/reference/offline-mode' },
          { slug: 'easydeploy/reference/troubleshooting' },
          { slug: 'easydeploy/reference/telemetry' },
          { slug: 'easydeploy/reference/faq' },
          { slug: 'easydeploy/reference/glossary' },
        ],
      },
    ],
  }),
],
});

