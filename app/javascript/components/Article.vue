<template>
  <v-container class="item elevation-3 article-container">
    <div class="article_detail">
      <v-layout xs-12 class="top-info-container">
        <!-- user が入ってからだけ表示（なくても落ちないように） -->
        <span
          class="user-name"
          v-if="article.user && article.user.name"
        >
          @{{ article.user.name }}
        </span>
        <time-ago
          :refresh="60"
          :datetime="article.updated_at"
          locale="en"
          tooltip="top"
          long
        ></time-ago>
        <v-spacer></v-spacer>

        <!-- 編集ボタン（開発中は常に表示） -->
        <v-btn
          text
          fab
          small
          class="mr-5"
          @click="moveToEditArticlePage(article.id)"
          v-if="editAble"
        >
          <v-icon color="#3085DE">fas fa-pencil-alt</v-icon>
        </v-btn>

        <!-- 削除ボタン（開発中は常に表示） -->
        <v-btn
          text
          fab
          small
          class="mr-2"
          @click="confirmDeleteArticle"
          v-if="editAble"
        >
          <v-icon color="#3085DE">fas fa-trash-alt</v-icon>
        </v-btn>
      </v-layout>

      <v-layout>
        <h1 class="article-title">{{ article.title }}</h1>
      </v-layout>

      <v-layout class="article-body-container">
        <div
          class="article-body"
          v-html="compiledMarkdown(article.body)"
        ></div>
      </v-layout>
    </div>
  </v-container>
</template>

<script>
import axios from "axios";
import TimeAgo from "vue2-timeago";
import marked from "marked";
import hljs from "highlight.js";
import Router from "../router/router";

const headers = {
  headers: {
    Authorization: "Bearer",
    "Access-Control-Allow-Origin": "*",
    "access-token": localStorage.getItem("access-token"),
    client: localStorage.getItem("client"),
    uid: localStorage.getItem("uid"),
  },
};

export default {
  components: {
    TimeAgo,
  },

  data() {
    return {
      // 最初から user を持たせておく（undefined で落ちないように）
      article: {
        user: {},
      },
    };
  },

  async created() {
    const renderer = new marked.Renderer();
    let data = "";
    renderer.code = function (code, lang) {
      const _lang = (lang || "").split(".").pop();
      try {
        data = hljs.highlight(_lang, code, true).value;
      } catch (e) {
        data = hljs.highlightAuto(code).value;
      }
      return `<pre><code class="hljs"> ${data} </code></pre>`;
    };

    marked.setOptions({
      renderer: renderer,
      tables: true,
      sanitize: true,
      langPrefix: "",
    });
  },

  mounted() {
    this.fetchArticle(this.$route.params.id);
  },

  computed: {
    compiledMarkdown() {
      return function (text) {
        return marked(text || "");
      };
    },

    // 🔥 開発中は常に編集・削除ボタンを出す
    editAble() {
      return true;
      // 本番用に戻すなら ↓
      // return (
      //   this.article.user &&
      //   localStorage.getItem("uid") === this.article.user.email
      // );
    },
  },

  methods: {
    async fetchArticle(id) {
      await axios
        .get(`/api/v1/articles/${id}`)
        .then((response) => {
          this.article = response.data || { user: {} };
        })
        .catch((e) => {
          console.log(e.response && e.response.data);
        });
    },

    moveToEditArticlePage(id) {
      Router.push(`/articles/${id}/edit`);
    },

    async confirmDeleteArticle() {
      const result = confirm("この記事を削除してもよろしいですか？");
      if (result) {
        await axios
          .delete(`/api/v1/articles/${this.article.id}`, headers)
          .then(() => {
            Router.push("/");
          })
          .catch((e) => {
            console.log(e.response && e.response.data);
          });
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.top-info-container {
  margin-bottom: 1em;
}
.article-container {
  margin-top: 2em;
  background: #fff;
  margin-bottom: 20px;
}
.article-title {
  font-size: 2.5em;
  line-height: 1.4;
}
.article-body {
  width: 100%;
}
.article-body-container {
  margin: 2em 0;
  font-size: 16px;
}
.user-name {
  margin-right: 1em;
}
</style>
