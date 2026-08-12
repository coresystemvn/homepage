// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';
import { SITE_DATA } from './src/constants';



// https://astro.build/config
export default defineConfig({
site: 'https://coresystem.vn',
base: '/',
trailingSlash: "ignore",
integrations: [
  starlight({
    title: SITE_DATA.name,                 // "CoreSystem"
    titleDelimiter: '|',
    description: SITE_DATA.description,    // mô tả dịch vụ chính, giữ nguyên
    favicon: '/favicon.svg',
    disable404Route: true,                  // dùng src/pages/404.astro hiện có
    pagefind: false,                        // tắt searchbar
    customCss: ['./src/styles/starlight.css'],
    components: {
      SiteTitle: './src/components/SiteTitle.astro',
      ThemeSelect: './src/components/ThemeToggle.astro',
      PageSidebar: './src/components/PageSidebar.astro',
    },
    sidebar: [
      { label: 'EasyDeploy', link: '/easydeploy/' },
      {
        label: 'Bắt đầu nhanh',
        items: [
          { slug: 'easydeploy/getting-started/quick-start' },
          { slug: 'easydeploy/getting-started/deploy-modes' },
          { slug: 'easydeploy/getting-started/rescue-tools' },
        ],
      },
      {
        label: 'MSP & Quản lý',
        items: [
          { slug: 'easydeploy/msp/overview' },
          { slug: 'easydeploy/msp/license-tiers' },
          { slug: 'easydeploy/msp/dashboard' },
          { slug: 'easydeploy/msp/usb-management' },
          { slug: 'easydeploy/msp/getting-started' },
          { slug: 'easydeploy/msp/bootbuilder' },
        ],
      },
      {
        label: 'Tùy biến Profiles',
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
        collapsed: true,
        items: [
          { slug: 'easydeploy/reference/configuration' },
          { slug: 'easydeploy/reference/keyboard-shortcuts' },
          { slug: 'easydeploy/reference/offline-mode' },
          { slug: 'easydeploy/reference/troubleshooting' },
          { slug: 'easydeploy/reference/telemetry' },
        ],
      },
    ],
  }),
],
});

