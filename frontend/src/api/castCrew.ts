// Curated, factual cast/crew/language info for the real movies in the seed
// catalog — event-service has no such fields yet, so this is a hand-picked
// lookup keyed by title (facts, not copyrightable), layered over the always
// visible synopsis. Movies not in this map (mock/offline fallback data,
// non-movie events) simply render without a Cast & Crew section.
export interface CastCrewInfo {
  language: string
  director: string
  cast: string[]
}

const CAST_CREW: Record<string, CastCrewInfo> = {
  // Tamil
  vikram: { language: 'Tamil', director: 'Lokesh Kanagaraj', cast: ['Kamal Haasan', 'Vijay Sethupathi', 'Fahadh Faasil', 'Suriya'] },
  master: { language: 'Tamil', director: 'Lokesh Kanagaraj', cast: ['Thalapathy Vijay', 'Vijay Sethupathi', 'Malavika Mohanan'] },
  '96': { language: 'Tamil', director: 'C. Prem Kumar', cast: ['Vijay Sethupathi', 'Trisha Krishnan'] },
  jailer: { language: 'Tamil', director: 'Nelson Dilipkumar', cast: ['Rajinikanth', 'Mohanlal', 'Jackie Shroff', 'Vinayakan'] },
  leo: { language: 'Tamil', director: 'Lokesh Kanagaraj', cast: ['Thalapathy Vijay', 'Trisha Krishnan', 'Sanjay Dutt'] },
  asuran: { language: 'Tamil', director: 'Vetrimaaran', cast: ['Dhanush', 'Manju Warrier'] },
  'vikram vedha': { language: 'Tamil', director: 'Pushkar-Gayathri', cast: ['Vijay Sethupathi', 'R. Madhavan'] },
  kaithi: { language: 'Tamil', director: 'Lokesh Kanagaraj', cast: ['Karthi'] },
  'soorarai pottru': { language: 'Tamil', director: 'Sudha Kongara', cast: ['Suriya', 'Aparna Balamurali'] },
  'super deluxe': { language: 'Tamil', director: 'Thiagarajan Kumararaja', cast: ['Vijay Sethupathi', 'Samantha'] },
  'pariyerum perumal': { language: 'Tamil', director: 'Mari Selvaraj', cast: ['Kathir'] },
  karnan: { language: 'Tamil', director: 'Mari Selvaraj', cast: ['Dhanush'] },
  'ponniyin selvan: i': { language: 'Tamil', director: 'Mani Ratnam', cast: ['Vikram', 'Aishwarya Rai Bachchan', 'Jayam Ravi'] },
  thunivu: { language: 'Tamil', director: 'H. Vinoth', cast: ['Ajith Kumar'] },
  'viduthalai part 1': { language: 'Tamil', director: 'Vetrimaaran', cast: ['Soori', 'Vijay Sethupathi'] },
  maanagaram: { language: 'Tamil', director: 'Lokesh Kanagaraj', cast: ['Sri', 'Regina Cassandra'] },
  jigarthanda: { language: 'Tamil', director: 'Karthik Subbaraj', cast: ['Siddharth', 'Bobby Simha'] },
  'sarpatta parambarai': { language: 'Tamil', director: 'Pa. Ranjith', cast: ['Arya'] },
  aadukalam: { language: 'Tamil', director: 'Vetrimaaran', cast: ['Dhanush'] },
  'anbe sivam': { language: 'Tamil', director: 'Sundar C.', cast: ['Kamal Haasan', 'R. Madhavan'] },

  // Hindi
  dangal: { language: 'Hindi', director: 'Nitesh Tiwari', cast: ['Aamir Khan', 'Fatima Sana Shaikh', 'Sanya Malhotra'] },
  '3 idiots': { language: 'Hindi', director: 'Rajkumar Hirani', cast: ['Aamir Khan', 'R. Madhavan', 'Sharman Joshi', 'Kareena Kapoor'] },
  'gully boy': { language: 'Hindi', director: 'Zoya Akhtar', cast: ['Ranveer Singh', 'Alia Bhatt'] },
  'zindagi na milegi dobara': { language: 'Hindi', director: 'Zoya Akhtar', cast: ['Hrithik Roshan', 'Farhan Akhtar', 'Abhay Deol', 'Katrina Kaif'] },
  andhadhun: { language: 'Hindi', director: 'Sriram Raghavan', cast: ['Ayushmann Khurrana', 'Tabu', 'Radhika Apte'] },
  queen: { language: 'Hindi', director: 'Vikas Bahl', cast: ['Kangana Ranaut'] },
  pink: { language: 'Hindi', director: 'Aniruddha Roy Chowdhury', cast: ['Amitabh Bachchan', 'Taapsee Pannu'] },
  'article 15': { language: 'Hindi', director: 'Anubhav Sinha', cast: ['Ayushmann Khurrana'] },
  'barfi!': { language: 'Hindi', director: 'Anurag Basu', cast: ['Ranbir Kapoor', 'Priyanka Chopra', 'Ileana D’Cruz'] },
  'rang de basanti': { language: 'Hindi', director: 'Rakeysh Omprakash Mehra', cast: ['Aamir Khan', 'Siddharth'] },
  lagaan: { language: 'Hindi', director: 'Ashutosh Gowariker', cast: ['Aamir Khan', 'Gracy Singh'] },
  swades: { language: 'Hindi', director: 'Ashutosh Gowariker', cast: ['Shah Rukh Khan'] },
  'taare zameen par': { language: 'Hindi', director: 'Aamir Khan', cast: ['Aamir Khan', 'Darsheel Safary'] },
  'gangs of wasseypur': { language: 'Hindi', director: 'Anurag Kashyap', cast: ['Manoj Bajpayee', 'Nawazuddin Siddiqui'] },
  'uri: the surgical strike': { language: 'Hindi', director: 'Aditya Dhar', cast: ['Vicky Kaushal'] },
  'kabir singh': { language: 'Hindi', director: 'Sandeep Reddy Vanga', cast: ['Shahid Kapoor', 'Kiara Advani'] },
  'bajrangi bhaijaan': { language: 'Hindi', director: 'Kabir Khan', cast: ['Salman Khan', 'Harshaali Malhotra'] },
  pk: { language: 'Hindi', director: 'Rajkumar Hirani', cast: ['Aamir Khan', 'Anushka Sharma'] },
  drishyam: { language: 'Hindi', director: 'Nishikant Kamat', cast: ['Ajay Devgn', 'Tabu'] },
  piku: { language: 'Hindi', director: 'Shoojit Sircar', cast: ['Deepika Padukone', 'Amitabh Bachchan', 'Irrfan Khan'] },

  // English
  'jurassic park': { language: 'English', director: 'Steven Spielberg', cast: ['Sam Neill', 'Laura Dern', 'Jeff Goldblum', 'Richard Attenborough'] },
  'blade runner 2049': { language: 'English', director: 'Denis Villeneuve', cast: ['Ryan Gosling', 'Harrison Ford', 'Ana de Armas'] },
  arrival: { language: 'English', director: 'Denis Villeneuve', cast: ['Amy Adams', 'Jeremy Renner', 'Forest Whitaker'] },
  inception: { language: 'English', director: 'Christopher Nolan', cast: ['Leonardo DiCaprio', 'Joseph Gordon-Levitt', 'Elliot Page', 'Tom Hardy'] },
  'the dark knight': { language: 'English', director: 'Christopher Nolan', cast: ['Christian Bale', 'Heath Ledger', 'Aaron Eckhart'] },
  interstellar: { language: 'English', director: 'Christopher Nolan', cast: ['Matthew McConaughey', 'Anne Hathaway'] },
  'the shawshank redemption': { language: 'English', director: 'Frank Darabont', cast: ['Tim Robbins', 'Morgan Freeman'] },
  'pulp fiction': { language: 'English', director: 'Quentin Tarantino', cast: ['John Travolta', 'Samuel L. Jackson', 'Uma Thurman'] },
  'fight club': { language: 'English', director: 'David Fincher', cast: ['Brad Pitt', 'Edward Norton'] },
  'the matrix': { language: 'English', director: 'Lana Wachowski, Lilly Wachowski', cast: ['Keanu Reeves', 'Laurence Fishburne'] },
  gladiator: { language: 'English', director: 'Ridley Scott', cast: ['Russell Crowe', 'Joaquin Phoenix'] },
  whiplash: { language: 'English', director: 'Damien Chazelle', cast: ['Miles Teller', 'J.K. Simmons'] },
  parasite: { language: 'English', director: 'Bong Joon-ho', cast: ['Song Kang-ho', 'Choi Woo-shik'] },
  'mad max: fury road': { language: 'English', director: 'George Miller', cast: ['Tom Hardy', 'Charlize Theron'] },
  'la la land': { language: 'English', director: 'Damien Chazelle', cast: ['Ryan Gosling', 'Emma Stone'] },
  'the grand budapest hotel': { language: 'English', director: 'Wes Anderson', cast: ['Ralph Fiennes'] },
  dunkirk: { language: 'English', director: 'Christopher Nolan', cast: ['Fionn Whitehead', 'Tom Hardy'] },
  oppenheimer: { language: 'English', director: 'Christopher Nolan', cast: ['Cillian Murphy', 'Emily Blunt', 'Robert Downey Jr.'] },
  dune: { language: 'English', director: 'Denis Villeneuve', cast: ['Timothée Chalamet', 'Rebecca Ferguson'] },
  'no country for old men': { language: 'English', director: 'Joel Coen, Ethan Coen', cast: ['Tommy Lee Jones', 'Javier Bardem', 'Josh Brolin'] },
}

export function getCastCrew(title: string): CastCrewInfo | undefined {
  return CAST_CREW[title.trim().toLowerCase()]
}
