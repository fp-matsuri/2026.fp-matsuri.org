/**
 * Foreign Function Interface for app.gleam
 */

/**
 * ページタイトルを更新する
 * @param {string} title - 新しいページタイトル
 */
export function setDocumentTitle(title) {
  document.title = title;
}

// TODO: 将来的な拡張用
// Open Graph Protocol (OGP) メタタグの動的更新機能
//
// 実装例:
// export function setOgpTags(title, description, url) {
//   const metaTags = {
//     'og:title': title,
//     'og:description': description,
//     'og:url': url,
//   };
//
//   Object.entries(metaTags).forEach(([property, content]) => {
//     let meta = document.querySelector(`meta[property="${property}"]`);
//     if (meta) {
//       meta.setAttribute('content', content);
//     }
//   });
// }
