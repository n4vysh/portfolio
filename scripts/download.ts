import { Destination, download } from "download";

const user = "n4vysh";

const file = [
  {
    src: `https://github.com/${user}/icon/releases/download/1.0.0/icon.svg`,
    dest: "icon.svg",
  },
  {
    src: `https://github.com/${user}/icon/releases/download/1.0.0/icon.png`,
    dest: "icon.png",
  },
];

file.map(async (item) => {
  try {
    const url = item.src;
    const destination: Destination = {
      file: item.dest,
      dir: "./public/images/",
    };
    const info = await download(url, destination);
    console.log(info);
  } catch (err) {
    console.log(err);
  }
});
