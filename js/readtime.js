function calculateReadTime() {
  var postBody = document.querySelector('.post-content');
  if (!postBody) { return; }

  var approxWordCount = postBody.innerText.split(' ').length;
  var readTimeMins = approxWordCount / 250; // standard wpm

  var readTime = Math.floor(readTimeMins);
  if (readTime === 0) {
    document.querySelector('.readtime').innerHTML = 'less than ' + 1 + ' min read';
  } else {
    document.querySelector('.readtime').innerHTML = 'approx ' + readTime + ' min read';
  }
}

document.addEventListener('DOMContentLoaded', calculateReadTime);