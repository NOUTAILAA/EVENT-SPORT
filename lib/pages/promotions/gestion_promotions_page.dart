import 'package:flutter/material.dart';
import '../../services/promotion_service.dart';
import '../../models/promotion.dart';
import 'dart:convert'; // Si tu veux récupérer des données JSON localement, sinon il est déjà dans service

class GestionPromotionsPage extends StatefulWidget {
  @override
  _GestionPromotionsPageState createState() => _GestionPromotionsPageState();
}

class _GestionPromotionsPageState extends State<GestionPromotionsPage> {
  late Future<List<Promotion>> futurePromotions;
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _remiseController = TextEditingController();
  bool isEditing = false;
  bool isAdding = false;
  int? editingPromotionId;

  final PromotionService _promotionService = PromotionService();

  @override
  void initState() {
    super.initState();
    futurePromotions = _promotionService.fetchPromotions();
  }

  // Ajouter ou mettre à jour une promotion
  Future<void> _savePromotion() async {
    final code = _codeController.text;
    final remise = double.tryParse(_remiseController.text) ?? 0;

    if (code.isEmpty || remise <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Veuillez remplir tous les champs')));
      return;
    }

    final promotion = Promotion(
      id: isEditing ? editingPromotionId! : 0,
      code: code,
      remise: remise,
    );

    try {
      await _promotionService.savePromotion(promotion);
      setState(() {
        futurePromotions = _promotionService.fetchPromotions();
        _codeController.clear();
        _remiseController.clear();
        isEditing = false;
        editingPromotionId = null;
        isAdding = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEditing ? 'Promotion mise à jour' : 'Promotion ajoutée')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout/édition de la promotion')));
    }
  }

  // Supprimer une promotion
  Future<void> _deletePromotion(int promotionId) async {
    try {
      await _promotionService.deletePromotion(promotionId);
      setState(() {
        futurePromotions = _promotionService.fetchPromotions();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Promotion supprimée')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la suppression de la promotion')));
    }
  }

  // Afficher la liste des promotions
  Widget _buildPromotionsList(List<Promotion> promotions) {
    return ListView.builder(
      itemCount: promotions.length,
      itemBuilder: (context, index) {
        final promotion = promotions[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Text(promotion.code),
            subtitle: Text('Remise: ${promotion.remise}%'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isEditing = true;
                      editingPromotionId = promotion.id;
                      _codeController.text = promotion.code;
                      _remiseController.text = promotion.remise.toString();
                      isAdding = true;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deletePromotion(promotion.id),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Promotions'),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Promotion>>(
        future: futurePromotions,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          } else {
            final promotions = snapshot.data ?? [];
            return Column(
              children: [
                // Formulaire pour ajouter/modifier
                if (isAdding)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _codeController,
                          decoration: InputDecoration(labelText: 'Code Promo'),
                        ),
                        TextField(
                          controller: _remiseController,
                          decoration: InputDecoration(labelText: 'Remise (%)'),
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _savePromotion,
                          child: Text(isEditing ? 'Mettre à jour la promotion' : 'Ajouter la promotion'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal, 
                            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                            textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(child: _buildPromotionsList(promotions)),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isAdding = true;
                        isEditing = false;
                        _codeController.clear();
                        _remiseController.clear();
                      });
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 30,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(20),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
