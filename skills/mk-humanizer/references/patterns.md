# AI Writing Patterns Catalog

Complete reference of patterns to identify and remove. Each pattern includes signal words, the problem it creates, and before/after examples.

Based on [Wikipedia:Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) plus academic research on AI text detection.

## Content Patterns

### P1. Undue Emphasis on Significance and Broader Trends

**Watch for:** stands/serves as, is a testament/reminder, a vital/significant/crucial/pivotal/key role/moment, underscores/highlights its importance, reflects broader, symbolizing its ongoing/enduring/lasting, setting the stage for, evolving landscape, indelible mark

**Problem:** AI puffs up importance by claiming arbitrary aspects represent or contribute to broader topics.

**Before:**
> The Statistical Institute of Catalonia was officially established in 1989, marking a pivotal moment in the evolution of regional statistics in Spain.

**After:**
> The Statistical Institute of Catalonia was established in 1989 to collect and publish regional statistics independently from Spain's national statistics office.

### P2. Undue Emphasis on Notability and Media Coverage

**Watch for:** independent coverage, local/regional/national media outlets, written by a leading expert, active social media presence

**Problem:** AI lists sources without context to hammer home notability.

**Before:**
> Her views have been cited in The New York Times, BBC, Financial Times, and The Hindu. She maintains an active social media presence with over 500,000 followers.

**After:**
> In a 2024 New York Times interview, she argued that AI regulation should focus on outcomes rather than methods.

### P3. Superficial Analyses with -ing Endings

**Watch for:** highlighting/underscoring/emphasizing..., ensuring..., reflecting/symbolizing..., contributing to..., cultivating/fostering..., encompassing..., showcasing...

**Problem:** AI tacks present participle phrases onto sentences to add fake depth.

**Before:**
> The temple's color palette resonates with the region's natural beauty, symbolizing Texas bluebonnets, reflecting the community's deep connection to the land.

**After:**
> The temple uses blue, green, and gold. The architect said these were chosen to reference local bluebonnets and the Gulf coast.

### P4. Promotional Language

**Watch for:** boasts a, vibrant, rich (figurative), profound, showcasing, exemplifies, commitment to, nestled, in the heart of, groundbreaking, renowned, breathtaking, stunning

**Problem:** AI can't keep a neutral tone, especially for descriptive topics.

**Before:**
> Nestled within the breathtaking region of Gonder, Alamata stands as a vibrant town with a rich cultural heritage and stunning natural beauty.

**After:**
> Alamata is a town in the Gonder region of Ethiopia, known for its weekly market and 18th-century church.

### P5. Vague Attributions and Weasel Words

**Watch for:** Industry reports, Observers have cited, Experts argue, Some critics argue, several sources/publications

**Problem:** AI attributes opinions to vague authorities without specific sources.

**Before:**
> Experts believe it plays a crucial role in the regional ecosystem.

**After:**
> The river supports several endemic fish species, according to a 2019 survey by the Chinese Academy of Sciences.

### P6. Formulaic "Challenges and Future Prospects"

**Watch for:** Despite its... faces several challenges..., Despite these challenges, Challenges and Legacy, Future Outlook

**Problem:** AI includes formulaic "challenges" sections that say nothing specific.

**Before:**
> Despite its industrial prosperity, Korattur faces challenges typical of urban areas. Despite these challenges, Korattur continues to thrive.

**After:**
> Traffic congestion increased after 2015 when three new IT parks opened. The municipal corporation began a stormwater drainage project in 2022.

## Language and Grammar Patterns

### P7. Overused AI Vocabulary

**High-frequency words:** Additionally, align with, crucial, delve, emphasizing, enduring, enhance, fostering, garner, highlight (verb), interplay, intricate/intricacies, key (adjective), landscape (abstract), pivotal, showcase, tapestry (abstract), testament, underscore (verb), valuable, vibrant

**Problem:** These words appear far more frequently in post-2023 text and often co-occur.

**Before:**
> Additionally, a distinctive feature is the incorporation of camel meat. An enduring testament to Italian influence is the widespread adoption of pasta in the local culinary landscape.

**After:**
> Somali cuisine also includes camel meat, considered a delicacy. Pasta dishes, introduced during Italian colonization, remain common in the south.

### P8. Copula Avoidance

**Watch for:** serves as/stands as/marks/represents [a], boasts/features/offers [a]

**Problem:** AI substitutes elaborate constructions for simple "is/are/has."

**Before:**
> Gallery 825 serves as LAAA's exhibition space. The gallery features four spaces and boasts over 3,000 square feet.

**After:**
> Gallery 825 is LAAA's exhibition space. The gallery has four rooms totaling 3,000 square feet.

### P9. Negative Parallelisms

**Watch for:** Not only...but..., It's not just about..., it's...

**Problem:** Overused construction that adds words without meaning.

**Before:**
> It's not just about the beat; it's part of the aggression and atmosphere. It's not merely a song, it's a statement.

**After:**
> The heavy beat adds to the aggressive tone.

### P10. Rule of Three Overuse

**Problem:** AI forces ideas into groups of three to appear comprehensive.

**Before:**
> The event features keynote sessions, panel discussions, and networking opportunities. Attendees can expect innovation, inspiration, and industry insights.

**After:**
> The event includes talks and panels. There's also time for informal networking between sessions.

### P11. Synonym Cycling (Elegant Variation)

**Problem:** AI has repetition-penalty code causing excessive synonym substitution.

**Before:**
> The protagonist faces many challenges. The main character must overcome obstacles. The central figure eventually triumphs. The hero returns home.

**After:**
> The protagonist faces many challenges but eventually triumphs and returns home.

### P12. False Ranges

**Problem:** AI uses "from X to Y" where X and Y aren't on a meaningful scale.

**Before:**
> Our journey has taken us from the singularity of the Big Bang to the grand cosmic web, from the birth of stars to the enigmatic dance of dark matter.

**After:**
> The book covers the Big Bang, star formation, and current theories about dark matter.

## Style Patterns

### P13. Em Dash Overuse

**Problem:** AI uses em dashes more than humans, mimicking "punchy" sales writing.

**Before:**
> The term is primarily promoted by Dutch institutions—not by the people themselves. You don't say "Netherlands, Europe"—yet this mislabeling continues—even in official documents.

**After:**
> The term is primarily promoted by Dutch institutions, not by the people themselves. You don't say "Netherlands, Europe" as an address, yet this mislabeling continues in official documents.

### P14. Overuse of Boldface

**Problem:** AI emphasizes phrases mechanically with bold.

**Before:**
> It blends **OKRs**, **KPIs**, and tools such as the **Business Model Canvas** and **Balanced Scorecard**.

**After:**
> It blends OKRs, KPIs, and visual strategy tools like the Business Model Canvas and Balanced Scorecard.

### P15. Inline-Header Vertical Lists

**Problem:** AI outputs lists where items start with bolded headers followed by colons.

**Before:**
> - **User Experience:** The user experience has been significantly improved.
> - **Performance:** Performance has been enhanced through optimized algorithms.
> - **Security:** Security has been strengthened with end-to-end encryption.

**After:**
> The update improves the interface, speeds up load times through optimized algorithms, and adds end-to-end encryption.

### P16. Title Case in Headings

**Problem:** AI capitalizes all main words in headings.

**Before:** `## Strategic Negotiations And Global Partnerships`
**After:** `## Strategic negotiations and global partnerships`

### P17. Emojis in Professional Content

**Problem:** AI decorates headings or bullets with emojis.

**Before:**
> 🚀 **Launch Phase:** The product launches in Q3
> 💡 **Key Insight:** Users prefer simplicity

**After:**
> The product launches in Q3. User research showed a preference for simplicity.

### P18. Curly Quotation Marks

**Problem:** ChatGPT uses curly quotes (“...”) instead of straight quotes ("...").

Replace curly quotes with straight quotes in all technical and code-adjacent writing.

## Communication Patterns

### P19. Collaborative Communication Artifacts

**Watch for:** I hope this helps, Of course!, Certainly!, You're absolutely right!, Would you like..., let me know, here is a...

**Problem:** Chatbot correspondence gets pasted as content.

**Before:**
> Great question! Here is an overview of the topic. I hope this helps! Let me know if you'd like me to expand on any section.

**After:**
> [Just the content, no chatbot wrapper]

### P20. Knowledge-Cutoff Disclaimers

**Watch for:** as of [date], Up to my last training update, While specific details are limited..., based on available information...

**Problem:** AI disclaimers about incomplete information left in text.

**Before:**
> While specific details about the company's founding are not extensively documented in readily available sources, it appears to have been established sometime in the 1990s.

**After:**
> The company was founded in 1994, according to its registration documents.

### P21. Sycophantic Tone

**Problem:** Overly positive, people-pleasing language.

**Before:**
> Great question! You're absolutely right that this is a complex topic. That's an excellent point.

**After:**
> The economic factors you mentioned are relevant here.

## Filler and Hedging

### P22. Filler Phrases

Common replacements:
- "In order to achieve this goal" → "To achieve this"
- "Due to the fact that" → "Because"
- "At this point in time" → "Now"
- "In the event that" → "If"
- "The system has the ability to" → "The system can"
- "It is important to note that" → [delete, just state the thing]

### P23. Excessive Hedging

**Problem:** Over-qualifying statements.

**Before:**
> It could potentially possibly be argued that the policy might have some effect on outcomes.

**After:**
> The policy may affect outcomes.

### P24. Generic Positive Conclusions

**Problem:** Vague upbeat endings.

**Before:**
> The future looks bright. Exciting times lie ahead as they continue their journey toward excellence.

**After:**
> The company plans to open two more locations next year.

## Structural Patterns (from academic research)

### P25. Low Burstiness / Uniform Sentence Rhythm

**Problem:** AI text has suspiciously even sentence lengths. Human writing naturally alternates between short punches and longer runs.

**Fix:** Vary sentence length deliberately. Follow a long sentence with a short one. Or a fragment. Then stretch out again.

### P26. Low Lexical Diversity

**Problem:** AI reuses the same narrow vocabulary throughout. Humans draw from a wider pool including informal words, domain jargon, and occasional unusual choices.

**Fix:** Don't just swap synonyms (that's P11). Instead, reach for the specific word that fits, even if it's less common.

### P27. Predictable Paragraph Structure

**Problem:** Every paragraph follows topic-sentence → supporting detail → conclusion. Humans don't write this uniformly.

**Fix:** Let some paragraphs start with a detail or question. Let others be one sentence. Break the template.

### P28. Strategic Imperfection Deficit

**Problem:** AI text is unnaturally clean — no tangents, self-corrections, hedged asides, or half-formed thoughts. Human writing has natural roughness.

**Fix:** For appropriate contexts (blog posts, ADRs, postmortems), leave in the human messiness. Don't polish everything smooth.

### P29. Formality Mismatch

**Problem:** AI defaults to formal register when casual works better: "utilize" instead of "use", "prior to" instead of "before", "in order to" instead of "to".

**Fix:** Match the formality to the audience. Developer docs should read like one engineer talking to another, not like a legal brief.

## Reference

Based on [Wikipedia:Signs of AI writing](https://en.wikipedia.org/wiki/Wikipedia:Signs_of_AI_writing) (patterns P1-P24) and academic research from ResearchGate, PMC, and ScienceDirect on AI text detection linguistics (patterns P25-P29).
