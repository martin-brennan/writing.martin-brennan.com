function calculateReadTime() {
  var postBody = document.querySelector('.post-content');
  if (!postBody) { return; }

  var approxWordCount = postBody.innerText.split(' ').length;
  var readTimeMins = approxWordCount / 250; // standard wpm

  var readTime = Math.floor(readTimeMins);
  document.querySelector('.readtime').innerHTML = 'approx ' + readTime + ' min read';
}

document.addEventListener('DOMContentLoaded', calculateReadTime);