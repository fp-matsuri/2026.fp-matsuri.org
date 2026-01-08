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
