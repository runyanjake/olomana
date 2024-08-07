const quotes = [
    {
        text: "The only way to do great work is to love what you do.",
        author: "Steve Jobs",
        link: "https://en.wikipedia.org/wiki/Steve_Jobs"
    },
    {
        text: "Success is not final, failure is not fatal: It is the courage to continue that counts.",
        author: "Winston Churchill",
        link: "https://en.wikipedia.org/wiki/Winston_Churchill"
    },
    {
        text: "In the end, it's not the years in your life that count. It's the life in your years.",
        author: "Abraham Lincoln",
        link: "https://en.wikipedia.org/wiki/Abraham_Lincoln"
    },
    {
        text: "Don't believe everything you read on the internet.",
        author: "Abraham Lincoln",
        link: "https://www.goodreads.com/quotes/4472530-the-problem-with-internet-quotes-is-that-you-cannot-always"
    },
    {
        text: "I should be on in a few minutes.",
        author: "Jake, in the moments before baiting",
        link: "https://www.youtube.com/channel/UCZctf3QSXXk9a5KzrAJ2bmw"
    },
    {
        text: "It's good news!",
        author: "Sujay",
        link: "https://anditsgood.news/"
    },
    {
        text: "It's bad news.",
        author: "Sujay",
        link: "https://anditsgood.news/"
    },
    {
        text: "Meow",
        author: "Tobee",
        link: "https://gallery.whitney.rip/library/albums/as3wif72i18kzs9q/tobee-and-maymay"
    },
    {
        text: "Meow",
        author: "MayMay",
        link: "https://gallery.whitney.rip/library/albums/as3wif72i18kzs9q/tobee-and-maymay"
    },
    {
        text: "It's your internet. Take it back.",
        author: "DWS",
        link: "https://dws.rip"
    },
];
const failureMessageQOTD = 'Failed to fetch the quote of the day. Please try again later.';

async function getQOTD() {
    var daysSinceEpoch = new Date().getTime() / (1000 * 60 * 60 * 24);
    const idx = Math.floor(daysSinceEpoch % quotes.length);
    return quotes[idx];
}

async function renderQOTD() {
    const quoteData = await getQOTD();
    const quoteElement = document.getElementById('quote-content');

    console.log(`Rendering Today's Quote: "${quoteData.text}" - ${quoteData.author}`);

    try {
        if(quoteData) {
            const html = `<p>"${quoteData.text}" - <a href="${quoteData.link}">${quoteData.author}</a></p>`;
            quoteElement.innerHTML = html;
        } else {
            quoteSection.innerHTML = `<p>${failureMessageQOTD}</p>`;
        }
    } catch (error) {
        console.error('Error rendering Quote of the Day:', error);
        quoteSection.innerHTML = `<p>${failureMessageQOTD}</p>`;
    }
}

console.log("Thanks for checking out PWS!");
document.addEventListener('DOMContentLoaded', renderQOTD);
