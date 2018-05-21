/* This code is to compute feature scores for moment matching technique
* Developed by Cong Duy Vu Hoang
* Updated: May 2018
*/

#pragma once

#include <string>
#include <vector>
#include <map>
#include <fstream>

using namespace std;

struct MMFeatures{ // abstract class
public:
	unsigned _num_samples;

	explicit MMFeatures(){}
	explicit MMFeatures(unsigned num_samples) : _num_samples(num_samples)
	{}

	virtual ~MMFeatures(){}

	virtual void compute_feature_scores(const WordIdSentences& xs, const WordIdSentences& ys, std::vector<float>& v_scores){
	}
};

// Feature specific for NMT
struct MMFeatures_NMT : public MMFeatures		 
{
	bool _fea_len_ratio = false;
	float _beta = 1.0f;
	
	bool _fea_bi_dict = false;
	std::string _bi_dict_filepath = "";
	std::map<std::pair<WordId, WordId>, unsigned> _bi_dict;
		
	bool _fea_pt_smt = false;
	std::string _pt_smt_file_path = "";
	unsigned _ngram = 3; // up to 3-gram matching

	bool _fea_cov = false;

	explicit MMFeatures_NMT(){	
	}

	virtual ~MMFeatures_NMT(){}

	explicit MMFeatures_NMT(unsigned num_samples, 
		bool fea_len_ratio, float beta,
		bool fea_bi_dict, const std::string& bi_dict_filepath,
		bool fea_pt_smt, const std::string& pt_smt_file_path, unsigned ngram,
		bool fea_cov)
		: MMFeatures(num_samples),
		_fea_len_ratio(fea_len_ratio), _beta(beta),
		_fea_bi_dict(fea_bi_dict), _bi_dict_filepath(bi_dict_filepath),
		_fea_pt_smt(fea_pt_smt), _pt_smt_file_path(pt_smt_file_path), _ngram(ngram),
		_fea_cov(fea_cov)
	{	
		if ("" != _bi_dict_filepath){
			ifstream inpf_bi_dict(_bi_dict_filepath);
			assert(inpf_bi_dict);

			std::string line;
			while (std::getline(inpf_bi_dict, line)){
				if ("" == line) continue;

				std::vector<std::string> words = split_words(line);
				assert(words.size() == 3);

				_bi_dict.insert(std::make_pair(std::make_pair(atoi(words[0].c_str()), atoi(words[1].c_str())), _bi_dict.size() - 1));
			}
		}
	}

	void get_len_ratio_feature(const WordIdSentence& x, const WordIdSentence& y, float& feature){
		if (_beta * x.size() < (float)y.size())
			feature = _beta * x.size() / (float)y.size();
		else feature = (float)y.size() / (_beta * x.size());
	}

	void get_bi_dict_feature(const WordIdSentence& x, const WordIdSentence& y, std::vector<float>& features){
		features.clear();
		features.resize(_bi_dict.size(), 0.f);
		for (auto& sword : x){
			for (auto& tword : y){
				const auto& iter = _bi_dict.find(std::make_pair(sword, tword));// FIXME: is this slow?
				if (iter != _bi_dict.end())//found
					features[iter->second] = 1.f;
			}
		}
	}

	void get_pt_smt_feature(const WordIdSentence& x, const WordIdSentence& y, std::vector<float>& features){
		// FIXME
	}

	void get_cov_feature(const WordIdSentence& x, const WordIdSentence& y, const vector<float>& align_probs, float& feature){
		// FIXME
	}
	
	virtual void compute_feature_scores(const WordIdSentences& xs, const WordIdSentences& ys, std::vector<float>& v_scores){
		v_scores.clear();
		
		for (unsigned s = 0; s < xs.size(); s++){
			const auto& src = xs[s];
			const auto& sample = ys[s];
			
			if (_fea_len_ratio){
				float f = 0.f;
				get_len_ratio_feature(src, sample, f);
				v_scores.push_back(f);
			}
			
			if (_fea_bi_dict){
				std::vector<float> v_f;
				get_bi_dict_feature(src, sample, v_f);
				v_scores.insert(v_scores.end(), v_f.begin(), v_f.end());
			}
			
			if (_fea_pt_smt){
				// FIXME
			}

			if (_fea_cov){
				// FIXME
			}
		}
	}
};

// Feature specific for DP (dependency parsing)
struct MMFeatures_DP : public MMFeatures		       
{
	explicit MMFeatures_DP(){	
	}

	explicit MMFeatures_DP(unsigned num_samples)
		: MMFeatures(num_samples)
	{	
	}

	virtual ~MMFeatures_DP(){}
};

// Feature specific for CP (constituency parsing)
struct MMFeatures_CP : public MMFeatures		 
{
	explicit MMFeatures_CP(){	
	}

	explicit MMFeatures_CP(unsigned num_samples)
		: MMFeatures(num_samples)
	{	
	}

	virtual ~MMFeatures_CP(){}
};

// Feature specific for WO (word ordering)
struct MMFeatures_WO : public MMFeatures		 
{
	explicit MMFeatures_WO(){	
	}

	explicit MMFeatures_WO(unsigned num_samples)
		: MMFeatures(num_samples)
	{	
	}

	virtual ~MMFeatures_WO(){}
};


