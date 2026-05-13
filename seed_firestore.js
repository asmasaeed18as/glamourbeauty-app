const admin = require("firebase-admin");
const serviceAccount = require("./glamorabeauty-1aea1-firebase-adminsdk-fbsvc-8f112e0f84.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();

const banners = [
  {
    id: "banner1",
    title: "Spring Glow Kit",
    subtitle: "Fresh tints, soft shimmer, and hydration-first picks.",
    imageUrl:
      "https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?auto=format&fit=crop&w=900&q=80",
    highlight: "Save 25%",
  },
  {
    id: "banner2",
    title: "Viral Essentials",
    subtitle: "Top-rated formulas your routine will actually use.",
    imageUrl:
      "https://images.unsplash.com/photo-1625093742435-6fa192b6fb10?auto=format&fit=crop&w=900&q=80",
    highlight: "Hot right now",
  },
];

const categories = [
  { id: "lips", name: "Lips", icon: "LP" },
  { id: "skin", name: "Skin", icon: "SK" },
  { id: "eyes", name: "Eyes", icon: "EY" },
  { id: "cheeks", name: "Cheeks", icon: "CH" },
  { id: "fragrance", name: "Fragrance", icon: "FG" },
];

const products = [
  {
    id: "p1",
    name: "Cloud Matte Lip Cream",
    brand: "Luma Beauty",
    category: "Lips",
    description:
      "A whipped matte lip cream with comfortable all-day wear and a blurring finish.",
    price: 18,
    rating: 4.8,
    reviewCount: 128,
    imageUrl:
      "https://images.unsplash.com/photo-1586495777744-4413f21062fa?auto=format&fit=crop&w=800&q=80",
    shades: ["Rose Blush", "Spiced Nude", "Berry Silk"],
    isFeatured: true,
    isNewArrival: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  },
  {
    id: "p2",
    name: "Dew Veil Skin Tint",
    brand: "Aurelia",
    category: "Skin",
    description:
      "A breathable skin tint that evens tone while keeping a radiant, natural finish.",
    price: 32,
    rating: 4.7,
    reviewCount: 84,
    imageUrl:
      "https://images.unsplash.com/photo-1596462502278-27bfdc403348?auto=format&fit=crop&w=800&q=80",
    shades: ["Ivory", "Sand", "Honey", "Walnut"],
    isFeatured: true,
    isNewArrival: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  },
  {
    id: "p3",
    name: "Silk Lash Mascara",
    brand: "Nova Face",
    category: "Eyes",
    description:
      "Lengthening mascara with a flexible brush for lift, curl, and clean separation.",
    price: 21,
    rating: 4.6,
    reviewCount: 63,
    imageUrl:
      "https://images.unsplash.com/photo-1512496015851-a90fb38ba796?auto=format&fit=crop&w=800&q=80",
    shades: ["Midnight", "Soft Brown"],
    isFeatured: false,
    isNewArrival: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  },
  {
    id: "p4",
    name: "Petal Flush Blush Balm",
    brand: "Maison Bloom",
    category: "Cheeks",
    description:
      "Cream blush balm that melts into skin for a sheer, watercolor glow.",
    price: 24,
    rating: 4.9,
    reviewCount: 151,
    imageUrl:
      "https://images.unsplash.com/photo-1515377905703-c4788e51af15?auto=format&fit=crop&w=800&q=80",
    shades: ["Peony", "Coral Kiss", "Warm Berry"],
    isFeatured: true,
    isNewArrival: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  },
  {
    id: "p5",
    name: "Velvet Oud Mist",
    brand: "Atelier Muse",
    category: "Fragrance",
    description:
      "A warm floral body mist with soft amber, rose, and sandalwood layers.",
    price: 29,
    rating: 4.5,
    reviewCount: 44,
    imageUrl:
      "https://images.unsplash.com/photo-1541643600914-78b084683601?auto=format&fit=crop&w=800&q=80",
    shades: ["100 ml"],
    isFeatured: false,
    isNewArrival: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  },
  {
    id: "p6",
    name: "Gloss Ritual Lip Oil",
    brand: "Luma Beauty",
    category: "Lips",
    description:
      "A nourishing lip oil with mirror shine and a cushiony, non-sticky feel.",
    price: 16,
    rating: 4.7,
    reviewCount: 92,
    imageUrl:
      "https://images.unsplash.com/photo-1619451334792-150fd785ee74?auto=format&fit=crop&w=800&q=80",
    shades: ["Sugar Petal", "Mocha Glaze", "Cherry Beam"],
    isFeatured: false,
    isNewArrival: true,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  },
];

async function seedCollection(collectionName, docs) {
  const batch = db.batch();

  for (const doc of docs) {
    const { id, ...data } = doc;
    const ref = db.collection(collectionName).doc(id);
    batch.set(ref, data, { merge: true });
  }

  await batch.commit();
  console.log(`Seeded ${collectionName}`);
}

async function main() {
  try {
    await seedCollection("banners", banners);
    await seedCollection("categories", categories);
    await seedCollection("products", products);
    console.log("Firestore seeding completed successfully.");
    process.exit(0);
  } catch (error) {
    console.error("Seeding failed:", error);
    process.exit(1);
  }
}

main();
