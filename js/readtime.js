function calculateReadTime() {
  var postBody = document.querySelector('.post-content');
  if (!postBody) { return; }

  var approxWordCount = postBody.innerText.split(' ').length;
  var readTimeMins = approxWordCount / 250; // standard wpm

  var readTime = Math.floor(readTimeMins);
  var el       = document.querySelector('.readtime');
  if (readTime === 0) {
    el.innerHTML = 'less than ' + 1 + ' min read';
  } else {
    el.innerHTML = 'approx ' + readTime + ' min read';
  }
  el.title = approxWordCount + ' words';
}

document.addEventListener('DOMContentLoaded', calculateReadTime);