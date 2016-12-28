var fs       = require('fs'),
readline = require('readline-sync');

var forSite = null;
process.argv.forEach(function(arg) {
    switch (arg) {
        case 'dev':
        case 'write':
            forSite = arg;
        break;
        case 'help':
            console.log('dev or write?');
            return false;
        break;
    }
});

var questions = [
    { q: 'what is the post title?', prop: 'title' },
    { q: 'what is the url permalink?', prop: 'permalink' }
];

if (forSite === 'write') {
    questions.push({ q: 'what is the post subtitle?', prop: 'subtitle' });
    questions.push({ q: 'what is the post header image url?', prop: 'headerimg' });
    questions.push({ q: 'what is the quotation to use?', prop: 'quote' });
    questions.push({ q: 'who is the quotation source?', prop: 'cite' });
}

var frontmatter = { title: null, subtitle: null, permalink: null, headerimg: null, quote: null, cite: null };

questions.forEach(function (question, index) {
    var answer = readline.question(question.q + ' ');
    if (answer.trim() !== '') {
        frontmatter[question.prop];
    }
});

var template = '----------\n';

Object.keys(frontmatter).forEach(function (key) {
    var val = frontmatter[key];
    if (val !== null && !['cite', 'quote'].indexOf(key)) {
        template += key + ': ' + val + '\n';
    }
});

template += 'date: ' + getLocalISOString() + '\n';
template += 'author: ' + 'Martin Brennan\n';
template += 'layout: ' + 'post\n';
template += '----------\n\n';

if (forSite === 'write' && frontmatter.quote !== null && frontmatter.cite !== null) {
    template += [
        '<blockquote class="hero">',
        '<p>',
        frontmatter.quote,
        '</p>',
        '<cite>— ' + frontmatter.cite + '</cite>',
        '</blockquote>\n'
    ].join('\n');
}

console.log(template);

fs.writeFile('./_drafts/' + frontmatter.title.toLowerCase().split(' ').join('-') + '.md', template, function (err) {
    if (err) {
        console.log(JSON.stringify(err));
    }
    console.log('new post created successfully in drafts!');
});

function getLocalISOString() {
    var tzoffset = (new Date()).getTimezoneOffset() * 60000;
    return (new Date(Date.now() - tzoffset)).toISOString().slice(0,-1) + '+10:00';
}